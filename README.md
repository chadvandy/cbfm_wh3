# Community Bug Fix Mod: Warhammer III
Community Bug-Fix Mod for Warhammer III. Please feel free to make pull requests, issues, etc!

### Getting Set Up

To get ready to work on the CBFM, you just need to have a GitHub account and the [GitHub Desktop](https://desktop.github.com/) application installed on your PC. You also need to have RPFM set up, with a MyMod path set.

Once the two above are done, open up GitHub Desktop and login to your account. Should be in "File -> Options". Then, in GitHub Desktop, press "File -> Clone Repository". This will make a "clone" of the CBFM repository of data on your own computer, which you can edit and change at will, locally.
Select "URL", decide a local path ending in "zzz_community_bugfix_mod", and then in the URL slot type in "chadvandy/cbfm_wh3". Press "Clone", and it will be added onto your PC on the path decided!

*You may have to make a "Fork" of this repository. That will be your own "version" of the CBFM repository, on your own github. Aside from that, everything will function as normal*

![Image showing the popup w/ an example "local path" set.](https://cdn.discordapp.com/attachments/597937992773926962/962385197674934292/unknown.png)

And now you have the entire repository of CBFM installed onto your PC. Next up you will want to go to RPFM -> MyMod -> Warhammer 3 -> New MyMod, and set the name to `zzz_community_bugfix_mod`. It will open an empty .pack called `zzz_community_bugfix_mod` - just use MyMod -> Import and it'll grab all the relevant files, and you're ready to go!

### Making Edits

Going forward, all you have to do is work on your edits. After each bugfix, please make a commit with a clear title that targets the "Issue" that is fixed with that commit - it'll be easier to keep track through that, instead of batch-editing fixes which can make it less wieldy with different db file names and the like. Make sure to have very clear file names, and always use `zzz_cbfm_` as the prefix for your file names if you aren't overwriting any vanilla files.

When you have a good set of fixes prepared, you will have to make a Pull Request. Be descriptive of your changes, and I or someone else will quickly review to make sure they pass standards and then pass them forward!

**VERY IMPORTANT:** If you delete a file in RPFM and use extract, *RPFM will not delete the file locally*, and so GitHub won't know to delete the file. You can just wipe the entire MyMod local folder prior to extracting the contents in RPFM, so you can assure your .pack file's contents are the only things on the repo.

### Rebasing your .Pack file

To make sure your .pack file is 100% lined up with our latest version, open up the MyMod file, delete everything within, and then use Import. This will pull in every single file from our repo, and will remove any leftover files on your end that might be old (if you haven't submitted a fix in a while, etc). You may also have to rebase your fork by changing branches or creating a new one based off of our master branch.

I'm sorry for all the github speak, google it if you don't know what I mean, I'm not helpful enough to detail everything. I'll probably edit this later to be more clear. Thanks!
