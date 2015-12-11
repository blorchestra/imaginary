# imaginary

This is free software inspired by the famous composition "Imaginary Landscape N° 4" of John Cage.

# Installation

This guide will help you to configure your SuperCollider installation to automatically load the imaginary patch. To detailed informations on how to download and install the SuperCollider programming language use the [official documentation](http://supercollider.github.io). After you have downloaded the Imaginary repository in you computer follow those steps:

1. Open SuperCollider go to *File* menu and select *open startup file*: this will open the file into the supercollider editor
2. Inside the local copy of Imaginary enter the folder *sccode*
3. Open the file *imaginary_startup.scd* in the supercollider editor
4. Type the command *"".resolveRelative* at the bottom of the file and execute it: this command shows the absolute path of your Imaginary code in the SuperCollider post window
5. Open the file *startup_code.scd* and substitute the *"/your/path/to/imaginary/"* with the path you have find in the step **4** (copy and paste it from the post window and don't forget the double quote "")
6. Copy the modified content of the *startup_code.scd* into the startup file opened in step **1**
7. Save the startup file
8. Restart the SuperCollider programming language

# Licence

This is free software and is released with a GPL_V3 licence that comes within this repository in tha agpl.txt file.
If you do not find an attached licence file you can retrieve the complete text [HERE](https://www.gnu.org/licenses/gpl-2.0.txt)
