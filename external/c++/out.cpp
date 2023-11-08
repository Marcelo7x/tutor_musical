#include <portaudio.h>
#include <cmath>
#include <chrono>


const double SAMPLE_RATE = 44100.0;
double BPM = 90.0;  // batidas por minuto
double FREQUENCY = 1000.0;  // frequência do som do metrônomo

int callback(const void* inputBuffer, void* outputBuffer, unsigned long framesPerBuffer,
             const PaStreamCallbackTimeInfo* timeInfo, PaStreamCallbackFlags statusFlags, void* userData) {
    float* out = (float*)outputBuffer;
    static double phase = 0.0;
    double phaseStep = FREQUENCY * 2.0 * M_PI / SAMPLE_RATE;
    static int beat = 0;
    int samplesPerBeat = (int)(SAMPLE_RATE * 60.0 / BPM);

    for (unsigned long i = 0; i < framesPerBuffer; i++) {
        if (beat < samplesPerBeat / 4)  // o som do metrônomo dura 1/4 de batida
            *out++ = (float)(0.2 * sin(phase));  // 0.2 é o volume
        else
            *out++ = 0.0;

        phase += phaseStep;
        if (phase > 2.0 * M_PI) phase -= 2.0 * M_PI;

        if (++beat >= samplesPerBeat) beat = 0;
    }

    return paContinue;
}

int metronome(int64_t initDelay = 0, int64_t seconds = 10, int32_t bpm = 90) {
    BPM = bpm;

    Pa_Initialize();

    PaStreamParameters outputParameters;
    outputParameters.device = Pa_GetDefaultOutputDevice();
    outputParameters.channelCount = 1;
    outputParameters.sampleFormat = paFloat32;
    outputParameters.suggestedLatency = Pa_GetDeviceInfo(outputParameters.device)->defaultLowOutputLatency;
    outputParameters.hostApiSpecificStreamInfo = NULL;

    PaStream* stream;
    Pa_OpenStream(&stream, NULL, &outputParameters, SAMPLE_RATE, 256, paClipOff, callback, NULL);

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
    Pa_StartStream(stream);

    Pa_Sleep(seconds * 1000);  // toque o metrônomo por x segundos

    Pa_StopStream(stream);
    Pa_CloseStream(stream);

    Pa_Terminate();

    return 0;
}

// int main() {
//     metronome(0L, 10L, 90);
//     return 0;
// }