import os, shutil, re
from stat import S_IREAD, S_IRGRP, S_IROTH, S_IWUSR

def replaceFileText(filepath, find, replace, b=''):
    with open(filepath, 'r'+b) as f:
        s = f.read()
    s = s.replace(find, replace)
    with open(filepath, 'w'+b) as f:
        f.write(s)

def unix_endings(filepath):
    replaceFileText(filepath, b'\r\n', b'\n', b='b')

def make_file(multifile, newfile):
    try:
        os.chmod(newfile, S_IWUSR | S_IREAD)  # This makes the file read/write for the owner
    except:
        pass

    with open(newfile, 'w') as mergedFile:
        with open(multifile, 'r') as classFile:
            for line in classFile:
                styFileMatch = re.match(r'.*usepackage\{(.*\+)\}.*', line)
                if styFileMatch:
                    mergedFile.write('\n')
                    styFilename = styFileMatch.group(1)+'.sty'
                    mergedFile.write('%'*80 + '\n')
                    mergedFile.write('%'*3 + ' '*12 + styFilename[:-4] + ' '*12 + '%'*3 + '\n')
                    mergedFile.write('%'*80 + '\n')
                    with open(styFilename, 'r') as styFile:
                        for line2 in styFile:
                            mergedFile.write('    '+line2)
                        mergedFile.write('\n')

                else:
                    mergedFile.write(line)

    unix_endings(newfile)


make_file(r'corpborepres+.cls',  './../corpborepres.cls')
make_file(r'corpborelone+.cls',  './../corpborelone.cls')
make_file(r'corpboreport+.cls',  './../corpboreport.cls')



if False: # exampleon how to copy something
    os.chmod(newfile, S_IREAD|S_IRGRP|S_IROTH)
    copyfile = newfile.replace('.cls', '-copy.cls')  # todo put MH location here
    if os.path.exists(copyfile):
        os.chmod(copyfile, S_IWUSR | S_IREAD)  # This makes the file read/write for the owner
        shutil.copyfile(newfile, copyfile)
        os.chmod(copyfile, S_IREAD | S_IRGRP | S_IROTH)


    