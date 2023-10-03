#include <iostream>
#include <vector>
#include "portaudio.h"
#include <sndfile.h>
#include "rec.hpp"
#include <aubio/aubio.h>

#define SAMPLE_RATE (44100)
#define FRAMES_PER_BUFFER (512)
#define NUM_SECONDS (10)
#define NUM_CHANNELS (2)

const bool WRITE_FILE = false;
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

int playCallback(const void *inputBuffer, void *outputBuffer,
                 unsigned long framesPerBuffer,
                 const PaStreamCallbackTimeInfo *timeInfo,
                 PaStreamCallbackFlags statusFlags,
                 void *userData)
{
    PaTestData *data = static_cast<PaTestData *>(userData);
    SAMPLE *rptr = &data->recordedSamples[data->frameIndex * NUM_CHANNELS];
    SAMPLE *wptr = static_cast<SAMPLE *>(outputBuffer);
    unsigned int i;
    int finished;
    unsigned int framesLeft = data->maxFrameIndex - data->frameIndex;

    (void)inputBuffer; // Prevent unused variable warnings.
    (void)timeInfo;
    (void)statusFlags;
    (void)userData;

    if (framesLeft < framesPerBuffer)
    {
        for (i = 0; i < framesLeft; i++)
        {
            *wptr++ = *rptr++; // left
            if (NUM_CHANNELS == 2)
                *wptr++ = *rptr++; // right
        }
        for (; i < framesPerBuffer; i++)
        {
            *wptr++ = 0; // left
            if (NUM_CHANNELS == 2)
                *wptr++ = 0; // right
        }
        data->frameIndex += framesLeft;
        finished = paComplete;
    }
    else
    {
        for (i = 0; i < framesPerBuffer; i++)
        {
            *wptr++ = *rptr++; // left
            if (NUM_CHANNELS == 2)
                *wptr++ = *rptr++; // right
        }
        data->frameIndex += framesPerBuffer;
        finished = paContinue;
    }
    return finished;
}

void rec()
{
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
        return;

    inputParameters.device = Pa_GetDefaultInputDevice();
    if (inputParameters.device == paNoDevice)
    {
        std::cerr << "Error: No default input device." << std::endl;
        return;
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
        return;

    err = Pa_StartStream(stream);
    if (err != paNoError)
        return;
    std::cout << "\n=== Now recording!! Please speak into the microphone. ===" << std::endl;

    while ((err = Pa_IsStreamActive(stream)) == 1)
    {
        Pa_Sleep(1000);
        std::cout << "index = " << data.frameIndex << std::endl;
    }
    if (err < 0)
        return;

    err = Pa_CloseStream(stream);
    if (err != paNoError)
        return;

    max = 0;
    average = 0.0;
    for (int i = 0; i < numSamples; i++)
    {
        val = data.recordedSamples[i];
        if (val < 0)
            val = -val;
        if (val > max)
        {
            max = val;
        }
        average += val;
    }

    average = average / static_cast<double>(numSamples);

    std::cout << "sample average = " << average << std::endl;

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
        FILE *outfile = fopen("./assets/rec/audio_data.txt", "w");
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

    // Playback recorded data.
    if (PLAYBACK_DATA)
    {
        data.frameIndex = 0;

        outputParameters.device = Pa_GetDefaultOutputDevice();
        if (outputParameters.device == paNoDevice)
        {
            std::cerr << "Error: No default output device." << std::endl;
            return;
        }
        outputParameters.channelCount = 2;
        outputParameters.sampleFormat = PA_SAMPLE_TYPE;
        outputParameters.suggestedLatency = Pa_GetDeviceInfo(outputParameters.device)->defaultLowOutputLatency;
        outputParameters.hostApiSpecificStreamInfo = nullptr;

        std::cout << "\n=== Now playing back. ===" << std::endl;
        err = Pa_OpenStream(
            &stream,
            nullptr,
            &outputParameters,
            SAMPLE_RATE,
            FRAMES_PER_BUFFER,
            paClipOff,
            playCallback,
            &data);
        if (err != paNoError)
            return;

        if (stream)
        {
            err = Pa_StartStream(stream);
            if (err != paNoError)
                return;

            std::cout << "Waiting for playback to finish." << std::endl;

            while ((err = Pa_IsStreamActive(stream)) == 1)
                Pa_Sleep(100);
            if (err < 0)
                return;

            err = Pa_CloseStream(stream);
            if (err != paNoError)
                return;

            std::cout << "Done." << std::endl;
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
    return;
}

int main()
{
    rec();
    return 0;
}