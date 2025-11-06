# finding-and-linking-files.md

*Date:* 2025-11-06

## Overview
The find command follows a syntax like this:
"find <path> <expression>" the path telling find where to search and the expression what exactly theyre looking for Ex: "find . -name 'report.txt'" the . specifies the current directory and that is the path find will start from, then you have you expression denoted by the flag -name and the name of the file being looked for is report.txt.
Wildcards for find used globs while wildcards for grep follow regex.
Examples of wildcards for the find command consist of:
- * matches zero or more characters -fine . -name "*.txt" -> all .txt files
- ? matches exactly one character - find . -name "file?.txt" -> file1.txt, fileA.txt, etc.
- [] matches any one of the enclosed characters or ranges - find . -name "file[0-9].txt" -> file 0.txt-file9.txt
- [!] matches any one character not listed - find . -name "file[!a-z].txt" -. files where the next char isnt a lowercase letter.

Most popular expression tests are "-name", "-iname", and "-type" which -iname makes the name finding case insensitive and capitalization no longer matters, -type is followed by the file type which will either be f, d, or l hwich are files, directories, and links and all can be combined to further refine your output.
A popular action expression is "-exec" which follows this syntax: "find <path> <expression> -exec <command> {} \;".

The exec flag executes whatever command you put inside to ever file find will find. "-ok" does the same but instead prompts you with a comfirmation.
If you were to pipe "|" find into the command "xargs", then it would act like "-ok" would if you were to flag xargs with "-p". Ex: "find . -name '*.log' | xargs -p rm".

If you want to locate the binary, source, and manual pages of a command, use "whereis" and if you want to fulter the results, use "-b" for only the binary files, and "-m" for only the manual files.
You can also use "which <command>" to see what a command may be aliased to or type <command> to see a more comprehensive look on how the shell will interpret a command name which includes aliases. You can use the "-a" with type to see all possible commands that match a name.

"ln" creates a hard link that works as an alias to the same file on disk. Both the original file and the hard link point to the same data so if one is deleted, the other still works unless all hard links are destroyed. These cannot span filesystems or disks and cannot point to directories.
"ln -s" creates a symbolic link which works as a shortcut that points to another file or directory by name. If the target is deleted then the symbolic link becomes broken and points to nothing.
"ls -i" shows the inode number which is a unique identifier for a file or directory on the filesystem. Like how PID are unique to processes.

## Key Commands
```bash
find <path> <expression>
whereis
which <command>
type <command>
ln
```

## Insights
Find has many uses along with various wildcards and multiple piping posibilites to allow for much versatility. There are quite a few commands for finding things

## Reflection
> This is exciting to write in nano and be my first official note made in the command line and commited, then pushed to github via my VM
