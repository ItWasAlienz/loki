LOKI was summoned by raja (aka 'ItWasAlienz')
Loki is an app designed to be a practice instrument, a song-writing tool, and a performance instrument all in one. 
The xox sequencer has features to make a steady beat grow irregular in various ways so that you can use it as an advanced metronome to practice to. 
The softcut layer is used for live-sampling in a choice of three modes: 'Stutter', 'Delay', and 'Looper'. 
Softcut voices can be routed into each other as well(so that you can record loops, feed them into stutters and delays, or pump the inputs through multiple delays, etc.).
A preset system allows for rudimentary song structuring(for now, presets are sequenced by manual trigger, either on the norns keys or using an external midi controller - 
the custom preset system was designed especially to be able to incorporate foot-controllers with program change so that presets can be incremented/decremented by foot, one by one).
With these features in place, the app facilitates usage, from practice, to song-structuring, all the way to stage performance.

Installation instructions:
1) from within maiden/matron type `;install https://github.com/ItWasAlienz/loki`
2) loki comes with audio files which you'll need to move to audio folder. after completing the previously mentioned `install` directive(watch the 'matron' terminal readout for when it says "...installed!"), you can then move these files by typing the following
into maiden/matron: `os.execute('mv '.._path.code.."loki/lokiaud ".._path.audio)`
