import sys
from aubio import source, pitch, onset, notes

def midi2note(midi_valor):
    notas = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    oitava = (midi_valor // 12) - 1
    nota = notas[midi_valor % 12]
    return f"{nota}{oitava}"

if len(sys.argv) < 2:
    print("Usage: %s <filename> [samplerate]" % sys.argv[0])
    sys.exit(1)

filename = sys.argv[1]

downsample = 1
samplerate = 44100 // downsample
if len( sys.argv ) > 2: samplerate = int(sys.argv[2])

win_s = 4096 // downsample # fft size
hop_s = 512  // downsample # hop size

s = source(filename, samplerate, hop_s)
samplerate = s.samplerate

tolerance = 0.8

pitch_o = pitch("yin", win_s, hop_s, samplerate)
pitch_o.set_unit("midi")
pitch_o.set_tolerance(tolerance)

pitches = []
confidences = []

sa,r = s()

# magnitude = np.abs(np.fft.fft(sa))
limite = 0.8 # Ajuste este valor conforme necessário


# total number of frames read
# total_frames = 0
# while True:
#     samples, read = s()
#     pitch = pitch_o(samples)[0]
#     #pitch = int(round(pitch))
#     confidence = pitch_o.get_confidence()
#     #if confidence < 0.8: pitch = 0.
#     if confidence > 0.98:
#         print("%f %s %f" % (total_frames / float(samplerate), midi2note(int(pitch)), confidence))
#     pitches += [pitch]
#     confidences += [confidence]
#     total_frames += read
#     if read < hop_s: break

total_frames = 0
file = open("/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/notes.txt", "w")
while True:
    samples, read = s()
    pitch = pitch_o(samples)[0]
    # pitch = int(round(pitch))
    confidence = pitch_o.get_confidence()
    # if confidence < 0.8: pitch = 0.
    if confidence > 0.9:
        note = midi2note(int(pitch))
        timestamp = total_frames / float(samplerate)
        line = (timestamp, note)
        file.write(str(timestamp) + ',' +  str(note) + '\n')
    pitches += [pitch]
    confidences += [confidence]
    total_frames += read
    if read < hop_s:
        break
    
file.close()


# # list of onsets, in samples
# win_s = 512                 # fft size
# hop_s = win_s // 2          # hop size


# samplerate = 0

# s = source(filename, samplerate, hop_s)
# samplerate = s.samplerate

# o = onset("default", win_s, hop_s, samplerate)
# onsets = []

# print("\n\n\nonsets: \n")
# while True:
#     samples, read = s()
#     if o(samples):
#         print("%f" % o.get_last_s())
#         onsets.append(o.get_last())
#     total_frames += read
#     if read < hop_s: break


print("\n\n\nnotes: \n")


downsample = 1
samplerate = 44100 // downsample


win_s = 512 // downsample # fft size
hop_s = 256 // downsample # hop size

s = source(filename, samplerate, hop_s)
samplerate = s.samplerate

tolerance = 0.8

notes_o = notes("default", win_s, hop_s, samplerate)

print("%8s" % "time","[ start","vel","last ]")

# total number of frames read
total_frames = 0
while True:
    samples, read = s()
    new_note = notes_o(samples)
    if (new_note[0] != 0):
        note_str = ' '.join(["%.2f" % i for i in new_note])
        print("%.6f %s" % (total_frames/float(samplerate), midi2note(int(new_note[0]))), new_note)
    total_frames += read
    if read < hop_s: break

if 0: sys.exit(0)

#print pitches
# import os.path
# from numpy import array, ma
# import matplotlib.pyplot as plt
# from demo_waveform_plot import get_waveform_plot, set_xlabels_sample2time

# skip = 1

# pitches = array(pitches[skip:])
# confidences = array(confidences[skip:])
# times = [t * hop_s for t in range(len(pitches))]

# fig = plt.figure()

# ax1 = fig.add_subplot(311)
# ax1 = get_waveform_plot(filename, samplerate = samplerate, block_size = hop_s, ax = ax1)
# plt.setp(ax1.get_xticklabels(), visible = False)
# ax1.set_xlabel('')

# def array_from_text_file(filename, dtype = 'float'):
#     filename = os.path.join(os.path.dirname(__file__), filename)
#     return array([line.split() for line in open(filename).readlines()],
#         dtype = dtype)

# ax2 = fig.add_subplot(312, sharex = ax1)
# ground_truth = os.path.splitext(filename)[0] + '.f0.Corrected'
# if os.path.isfile(ground_truth):
#     ground_truth = array_from_text_file(ground_truth)
#     true_freqs = ground_truth[:,2]
#     true_freqs = ma.masked_where(true_freqs < 2, true_freqs)
#     true_times = float(samplerate) * ground_truth[:,0]
#     ax2.plot(true_times, true_freqs, 'r')
#     ax2.axis( ymin = 0.9 * true_freqs.min(), ymax = 1.1 * true_freqs.max() )
# # plot raw pitches
# ax2.plot(times, pitches, '.g')
# # plot cleaned up pitches
# cleaned_pitches = pitches
# #cleaned_pitches = ma.masked_where(cleaned_pitches < 0, cleaned_pitches)
# #cleaned_pitches = ma.masked_where(cleaned_pitches > 120, cleaned_pitches)
# cleaned_pitches = ma.masked_where(confidences < tolerance, cleaned_pitches)
# ax2.plot(times, cleaned_pitches, '.-')
# #ax2.axis( ymin = 0.9 * cleaned_pitches.min(), ymax = 1.1 * cleaned_pitches.max() )
# #ax2.axis( ymin = 55, ymax = 70 )
# plt.setp(ax2.get_xticklabels(), visible = False)
# ax2.set_ylabel('f0 (midi)')

# # plot confidence
# ax3 = fig.add_subplot(313, sharex = ax1)
# # plot the confidence
# ax3.plot(times, confidences)
# # draw a line at tolerance
# ax3.plot(times, [tolerance]*len(confidences))
# ax3.axis( xmin = times[0], xmax = times[-1])
# ax3.set_ylabel('confidence')
# set_xlabels_sample2time(ax3, times[-1], samplerate)
# plt.show()
#plt.savefig(os.path.basename(filename) + '.svg')