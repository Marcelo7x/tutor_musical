#include <iostream>
#include <vector>
#include "portaudio.h"
#include <sndfile.h>
#include "rec.hpp"
#include <aubio/aubio.h>
#include <chrono>
#include <thread>
#include "out.cpp"

#define SAMPLE_RATE (44100)
#define FRAMES_PER_BUFFER (512)
#define NUM_CHANNELS (2)

int32_t NUM_SECONDS  = 30;
const bool WRITE_FILE = true;
const bool PLAYBACK_DATA = false;

enum SampleFormat
{
    Float32,
    Int16,
    Int8,
    UInt8
};

#define PA_SAMPLE_TYPE paFloat32
using SAMPLE = float;
const SAMPLE SAMPLE_SILENCE = 0.0f;
const char *PRINTF_S_FORMAT = "%.8f";

struct PaTestData
{
    int frameIndex;
    int maxFrameIndex;
    std::vector<SAMPLE> recordedSamples;
};

int recordCallback(const void *inputBuffer, void *outputBuffer,
                   unsigned long framesPerBuffer,
                   const PaStreamCallbackTimeInfo *timeInfo,
                   PaStreamCallbackFlags statusFlags,
                   void *userData)
{
    PaTestData *data = static_cast<PaTestData *>(userData);
    const SAMPLE *rptr = static_cast<const SAMPLE *>(inputBuffer);
    SAMPLE *wptr = &data->recordedSamples[data->frameIndex * NUM_CHANNELS];
    long framesToCalc;
    long i;
    int finished;
    unsigned long framesLeft = data->maxFrameIndex - data->frameIndex;

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
            if (NUM_CHANNELS == 2)
                *wptr++ = SAMPLE_SILENCE; // right
        }
    }
    else
    {
        for (i = 0; i < framesToCalc; i++)
        {
            *wptr++ = *rptr++; // left
            if (NUM_CHANNELS == 2)
                *wptr++ = *rptr++; // right
        }
    }
    data->frameIndex += framesToCalc;
    return finished;
}

int64_t rec(int64_t seconds, int64_t initDelay, bool withMetronome, int32_t bpm)
{
    NUM_SECONDS = seconds;

    PaStreamParameters inputParameters, outputParameters;
    PaStream *stream;
    PaError err = paNoError;
    PaTestData data;
    int totalFrames;
    int numSamples;
    int numBytes;
    SAMPLE max, val;
    double average;

    std::cout << "patest_record.cpp" << std::endl;

    data.maxFrameIndex = totalFrames = NUM_SECONDS * SAMPLE_RATE;
    data.frameIndex = 0;
    numSamples = totalFrames * NUM_CHANNELS;
    numBytes = numSamples * sizeof(SAMPLE);
    data.recordedSamples.resize(numSamples, 0.0f);

    err = Pa_Initialize();
    if (err != paNoError)
        return -1;

    inputParameters.device = Pa_GetDefaultInputDevice();
    if (inputParameters.device == paNoDevice)
    {
        std::cerr << "Error: No default input device." << std::endl;
        return -1;
    }
    inputParameters.channelCount = 2;
    inputParameters.sampleFormat = PA_SAMPLE_TYPE;
    inputParameters.suggestedLatency = Pa_GetDeviceInfo(inputParameters.device)->defaultLowInputLatency;
    inputParameters.hostApiSpecificStreamInfo = nullptr;

    err = Pa_OpenStream(
        &stream,
        &inputParameters,
        nullptr,
        SAMPLE_RATE,
        FRAMES_PER_BUFFER,
        paClipOff,
        recordCallback,
        &data);
    if (err != paNoError)
        return -1;
    

    std::thread t;
    
    if (withMetronome)
    {
        t = std::thread(metronome, initDelay,seconds, bpm);
    }

    auto now = std::chrono::system_clock::now();
    auto now_ms = std::chrono::time_point_cast<std::chrono::milliseconds>(now);
    auto epoch = now_ms.time_since_epoch();
    auto value = std::chrono::duration_cast<std::chrono::milliseconds>(epoch);

    if (initDelay != 0){
        while (initDelay > value.count())
        {
            now = std::chrono::system_clock::now();
            now_ms = std::chrono::time_point_cast<std::chrono::milliseconds>(now);
            epoch = now_ms.time_since_epoch();
            value = std::chrono::duration_cast<std::chrono::milliseconds>(epoch);
        }
        // std::cout << 'sai\n'; 
    }

    err = Pa_StartStream(stream);
    if (err != paNoError)
        return -1;
    std::cout << "\n=== Now recording ===" << std::endl;

    while ((err = Pa_IsStreamActive(stream)) == 1)
    {
        Pa_Sleep(1000);
        // std::cout << "index = " << data.frameIndex << std::endl;
    }
    if (err < 0)
        return-1;

    err = Pa_CloseStream(stream);
    if (err != paNoError)
        return-1;

    // Write recorded data to a file.
    SF_INFO sfinfo;
    sfinfo.channels = NUM_CHANNELS;
    sfinfo.samplerate = SAMPLE_RATE;
    sfinfo.format = SF_FORMAT_WAV | SF_FORMAT_PCM_16;

    SNDFILE *out = sf_open("/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/gravacao.wav", SFM_WRITE, &sfinfo);
    if (!out)
    {
        std::cerr << "Erro ao abrir o arquivo de saída." << std::endl;
    }
    else
    {
        sf_writef_float(out, data.recordedSamples.data(), totalFrames);
        sf_close(out);
        std::cout << "Dados gravados em 'gravacao.wav'" << std::endl;
    }

    if (WRITE_FILE)
    {
        FILE *outfile = fopen("/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/audio_data.txt", "w");
        if (!outfile)
        {
            std::cerr << "Erro ao abrir o arquivo para gravação." << std::endl;
        }
        else
        {
            for (int i = 0; i < numSamples; i++)
            {
                fprintf(outfile, "%.8f\n", data.recordedSamples[i]);
            }
            fclose(outfile);
            std::cout << "Dados de amplitude gravados em 'audio_data.txt'" << std::endl;
        }
    }

done:
    Pa_Terminate();
    if (err != paNoError)
    {
        std::cerr << "An error occurred while using the portaudio stream" << std::endl;
        std::cerr << "Error number: " << err << std::endl;
        std::cerr << "Error message: " << Pa_GetErrorText(err) << std::endl;
        err = 1;
    }

    if (withMetronome)
    {
        t.join();
    }
    
    
    return value.count();
}

int main()
{
    rec(30L, 0L, true, 90);
    return 0;
}