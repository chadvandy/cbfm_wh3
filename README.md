# cbfm_wh3
Community Bug-Fix Mod for Warhammer III. Please feel free to make pull requests, issues, etc!

### Getting Set Up

To get ready to work on the CBFM, you just need to have a GitHub account and the [GitHub Desktop](https://desktop.github.com/) application installed on your PC.

Once the two above are done, open up GitHub Desktop and login to your account. Should be in "File -> Options". Then, in GitHub Desktop, press "File -> Clone Repository". This will make a "clone" of the CBFM repository of data on your own computer, which you can edit and change at will, locally.
Select "URL", decide a local path, and then in the URL slot type in "chadvandy/community_bugfix_mod". Press "Clone", and it will be added onto your PC on the path decided!

And now you have the entire repository of CBFM installed onto your PC. I recommend setting the "local path" as the `community_bugfix_mod` folder in your MyMod folder, to make everything even easier.

### Making Edits

Before you get started making edits to the CBFM mod, you've gotta do two things. First off, in GitHub Desktop, where it says "Current repository", make sure it says the CBFM repo. And in "Current branch", select it and press "New branch", to make your own new "branch" of data. This will help us with merging all the different flows of changes; if several people edit the same table or file, we'll be able to see who did what and how to combine them.
Then, in RPFM, open up your CBFM MyMod, clear out everything within it, and use "Add Folder... ->", and target the community_bugfix_mod MyMod folder. This will make sure your local copy of RPFM is up-to-date with the latest release of CBFM retail before you get working.

At that point, your RPFM .pack is 100% up-to-date with CBFM's live version, and you can start making edits within RPFM. 
Once you're done and have tested, simply right click your .pack in RPFM, press "Extract", and everything will automatically be sent to the MyMod folder.

**VERY IMPORTANT:** If you delete a file in RPFM and use extract, *RPFM will not delete the file locally*, and so GitHub won't know to delete the file. You can just wipe the entire MyMod local folder prior to extracting the contents in RPFM, so you can assure your .pack file's contents are the only things on the repo.

Once you've made your changes there, make a "Commit". In GitHub Desktop, it will see all of the various changed files in the left column, and below that it will ask for a Summary and Description. Give as regular commits as you can so it's easier to track what went on, and give some good details as well.
Once you're done with all your commits and you're ready to send your new branch for submission, press "Publish Branch", which will submit it into the GitHub repo for others to see. If you've already pressed "Publish Branch", use "Push Branch", to "push" the local files you've changed onto the public repo.
