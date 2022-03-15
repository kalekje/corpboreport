
import os, shutil, re
from stat import S_IREAD, S_IRGRP, S_IROTH, S_IWUSR

def make_file(multifile, newfile):
    try:
        os.chmod(newfile, S_IWUSR | S_IREAD)  # This makes the file read/write for the owner
    except:
        pass

    with open(newfile, 'w') as mergedFile:
        with open(multifile, 'r') as classFile:
            for line in classFile:
                styFileMatch = re.match(r'.*\{\\FormatDir (.*)\}.*', line)
                if styFileMatch:
                    mergedFile.write('\n')
                    styFilename = styFileMatch.group(1)+'.sty'
                    mergedFile.write('%'*12 + '  ' + styFilename + '  ' + '%'*12 + '\n')
                    with open(styFilename, 'r') as styFile:
                        for line2 in styFile:
                            mergedFile.write('    '+line2)
                        mergedFile.write('\n')

                else:
                    mergedFile.write(line)


make_file(r'corpboreportMulti.cls',  './../corpboreport.cls')
make_file(r'corpborepresMulti.cls',  './../corpborepres.cls')
make_file(r'corpboreloneMulti.cls',  './../corpborelone.cls')
make_file(r'cbthesisMulti.cls',  './../cbthesis.cls')





if False: # exampleon how to copy something
    os.chmod(newfile, S_IREAD|S_IRGRP|S_IROTH)
    copyfile = newfile.replace('.cls', '-copy.cls')  # todo put MH location here
    if os.path.exists(copyfile):
        os.chmod(copyfile, S_IWUSR | S_IREAD)  # This makes the file read/write for the owner
        shutil.copyfile(newfile, copyfile)
        os.chmod(copyfile, S_IREAD | S_IRGRP | S_IROTH)


    
