# **LOKI** 
### was summoned by raja (aka 'ItWasAlienz')
Loki is an app designed to be a practice instrument, a song-writing tool, and a performance instrument all in one. 
The xox sequencer has features to make a steady beat grow irregular in various ways so that you can use it as an advanced metronome to practice to. 
The softcut layer is used for live-sampling in a choice of three modes: 'Stutter', 'Delay', and 'Looper'. 
Softcut voices can be routed into each other as well(so that you can record loops, feed them into stutters and delays, or pump the inputs through multiple delays, etc.).
A preset system allows for rudimentary song structuring(for now, presets are sequenced by manual trigger, either on the norns keys or using an external midi controller(eventually an additional automated preset sequencer will be added) - 
the custom preset system was designed especially to be able to incorporate foot-controllers with program change so that presets can be incremented/decremented by foot, one by one; in addition, this system allows for separate presets to apply to the xox sequencer as opposed to the softcut voices, and parameters can be frozen in place when loading presets, so that only partial presets are loaded if so desired, all in all, allowing for many different recombinations to happen from minimal settings).

### Installation instructions:
1) from within maiden/matron's REPL type:
   
        ;install https://github.com/ItWasAlienz/loki
   
3) loki comes with audio files which you'll need to move to your norns's 'audio' folder. 
after completing the previously mentioned `install` directive(watch the 'matron' terminal readout for when it says 'installed "loki"!'), you can then move these files to the appropriate 'audio' folder by typing the following into maiden/matron's REPL:
  
        os.execute('mv '.._path.code.."loki/lokiaud ".._path.audio)

after doing this, the REPL should display "true	exit	0" to indicate success, and 'lokiaud' folder will then be located within your norns 'audio' folder(if installing from a web-browser, you may need to refresh to see the change). You can then start the app and begin playing 🔊 🥰
