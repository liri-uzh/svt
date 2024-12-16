# About
DatabaseExplorer is a [Praat](https://www.fon.hum.uva.nl/praat/) plugin for you to intuitively inspect a folder containing speech files, cut them into snippets and save them to a different location, with just some simple clicks of your mouse.

Databases typically have many files in one directory. In Praat it can be a bit bulky to run through a file collection. The fundamental idea of databaseExplorer is that you can simply loop through a number of files in a directory and can carry out simple edits. To change from one file to the next or back, you can simply use the arrow buttons.

- Input: Sound object(s) selected in Praat object window.
- Output (optional): Sound with a TextGrid taht is saved in a directory of your choice. 

![Home screen of databaseExplorer.](./images/database_Explorer.png)

# Demonstration
This short **[video](https://www.youtube.com/watch?v=fjlFNOzfdPo)** produced by Clemens Lutz from LiRI Resource Hub efficiently demonstrates you everything about databaseExplorer, from the installation to the usage. Be sure to ckeck it out 😉!

# Installation
- Method 1 (recommended): Copy the directory `./plugin_databaseExplorer` into the [Praat preferences directory](https://www.fon.hum.uva.nl/praat/manual/preferences_folder.html): \
  Assuming you're user `liri`:, \
  on Windows: `C:\Users\liri\Praat\`; \
  on MacOS: `/Users/liri/Library/Preferences/Praat Prefs/`; \
  on Linux: `/home/liri/.praat-dir/`.\
  Then reopen Praat, databaseExplorer automatically appears in Praat under ‘New > PresenterPro’, in Praat Objects window.
- Method 2: Execute the script `setup.praat` that’s inside the directory. \
  **Note**: if using this method, the plugin folder should not be moved somewhere else after executing the script, otherwise it couldn’t be found next time. Therefore highly recommend to use method 1.

<div align="center">
  <img src="./images/Praat_objects_window_selected.png" alt="Entry of databaseExplorer in Praat." style="width: 50%;">
</div>

# Author
[Prof. Volker Dellwo](https://www.liri.uzh.ch/en/aboutus/Volker-Dellwo.html)

# Question, Feedback and Contribution
We appreciate any question, feedback and contribution to the code, please refer to the [general contribution guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) for more information.

# License
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation (see <http://www.gnu.org/licenses/>). This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY.
