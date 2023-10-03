#include <iostream>
#include <vector>
#include "portaudio.h"
#include <sndfile.h>

#define PA_SAMPLE_TYPE paFloat32
using SAMPLE = float;

class AudioRecorder
{
public:
    AudioRecorder(const int sample_rate,
                  const int frames_per_buffer,
                  const int num_seconds,
                  const int num_channels) : sample_rate(sample_rate),
                                            frames_per_buffer(frames_per_buffer),
                                            num_seconds(num_seconds),
                                            num_channels(num_channels), frameIndex(0), maxFrameIndex(0)
    {
        Pa_Initialize();
    }

    ~AudioRecorder()
    {
        Pa_Terminate();
    }

    bool Initialize()
    {
        PaError err = paNoError;

        maxFrameIndex = num_seconds * sample_rate;
        frameIndex = 0;
        int numSamples = maxFrameIndex * num_channels;
        int numBytes = numSamples * sizeof(SAMPLE);
        recordedSamples.resize(numSamples, 0.0f);

        inputParameters.device = Pa_GetDefaultInputDevice();
        if (inputParameters.device == paNoDevice)
        {
            std::cerr << "Error: No default input device." << std::endl;
            return false;
        }

        inputParameters.channelCount = num_channels;
        inputParameters.sampleFormat = PA_SAMPLE_TYPE;
        inputParameters.suggestedLatency = Pa_GetDeviceInfo(inputParameters.device)->defaultLowInputLatency;
        inputParameters.hostApiSpecificStreamInfo = nullptr;

        err = Pa_OpenStream(
            &stream,
            &inputParameters,
            nullptr,
            sample_rate,
            frames_per_buffer,
            paClipOff,
            recordCallback,
            this);

        if (err != paNoError)
            return false;

        return true;
    }

    bool StartRecording()
    {
        PaError err = paNoError;

        err = Pa_StartStream(stream);

        if (err != paNoError)
            return false;

        return true;
    }

    bool IsRecording()
    {
        return Pa_IsStreamActive(stream) == 1;
    }

    bool StopRecording()
    {
        PaError err = paNoError;

        err = Pa_CloseStream(stream);

        if (err != paNoError)
            return false;

        return true;
    }

    bool SaveToFile(const char *filename)
    {
        SF_INFO sfinfo;
        sfinfo.channels = num_channels;
        sfinfo.samplerate = sample_rate;
        sfinfo.format = SF_FORMAT_WAV | SF_FORMAT_PCM_16;

        SNDFILE *out = sf_open(filename, SFM_WRITE, &sfinfo);
        if (!out)
        {
            std::cerr << "Error opening output file." << std::endl;
            return false;
        }

        sf_writef_float(out, recordedSamples.data(), maxFrameIndex);
        sf_close(out);

        return true;
    }

private:
    int frameIndex;
    int maxFrameIndex;
    const int sample_rate;
    const int frames_per_buffer;
    const int num_seconds;
    const int num_channels;
    const char *PRINTF_S_FORMAT = "%.8f";

    const SAMPLE SAMPLE_SILENCE = 0.0f;


    std::vector<SAMPLE> recordedSamples;
    PaStream *stream;
    PaStreamParameters inputParameters;

    int recordCallback(const void *inputBuffer, void *outputBuffer,
                              unsigned long framesPerBuffer,
                              const PaStreamCallbackTimeInfo *timeInfo,
                              PaStreamCallbackFlags statusFlags,
                              void *userData)
    {
        AudioRecorder *recorder = static_cast<AudioRecorder *>(userData);
        const SAMPLE *rptr = static_cast<const SAMPLE *>(inputBuffer);
        SAMPLE *wptr = &recorder->recordedSamples[recorder->frameIndex * num_channels];
        long framesToCalc;
        long i;
        int finished;
        unsigned long framesLeft = recorder->maxFrameIndex - recorder->frameIndex;

        (void)outputBuffer; // Prevent unused variable warnings.
        (void)timeInfo;
        (void)statusFlags;
        (void)userData;

        if (framesLeft < framesPerBuffer)
        {
            framesToCalc = framesLeft;
            finished = paComplete;
        }
        else
        {
            framesToCalc = framesPerBuffer;
            finished = paContinue;
        }

        if (inputBuffer == nullptr)
        {
            for (i = 0; i < framesToCalc; i++)
            {
                *wptr++ = SAMPLE_SILENCE; // left
                if (num_channels == 2)
                    *wptr++ = SAMPLE_SILENCE; // right
            }
        }
        else
        {
            for (i = 0; i < framesToCalc; i++)
            {
                *wptr++ = *rptr++; // left
                if (num_channels == 2)
                    *wptr++ = *rptr++; // right
            }
        }
        recorder->frameIndex += framesToCalc;

        return finished;
    }
};

int main()
{
    AudioRecorder recorder(44100, 512, 10 , 2);

    if (!recorder.Initialize())
    {
        std::cerr << "Initialization failed." << std::endl;
        return 1;
    }

    std::cout << "Recording... Press Enter to stop." << std::endl;
    if (!recorder.StartRecording())
    {
        std::cerr << "Recording failed." << std::endl;
        return 1;
    }

    // Wait for user to press Enter to stop recording.
    std::cin.get();

    if (!recorder.StopRecording())
    {
        std::cerr << "Stopping recording failed." << std::endl;
        return 1;
    }

    if (recorder.SaveToFile("recording.wav"))
    {
        std::cout << "Recording saved to 'recording.wav'." << std::endl;
    }
    else
    {
        std::cerr << "Saving recording failed." << std::endl;
        return 1;
    }

    return 0;
}
