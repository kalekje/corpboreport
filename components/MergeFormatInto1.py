import os, shutil, re
from stat import S_IREAD, S_IRGRP, S_IROTH, S_IWUSR
import socket

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


MH_path = r'S:\Kale Ewasiuk\LaTeX\template files\\'

for cls in 'pres lone port'.split():
    f_component = 'corpbore'+cls+'+.cls'
    f = 'corpbore'+cls+'.cls'
    f_compiled = './..//'+f
    make_file(f_component,  f_compiled)
    os.chmod(f_compiled, S_IREAD | S_IRGRP | S_IROTH)

    if socket.gethostname().startswith('MH'):  #  if MH computer is used, make a copy for shared usage
        f_MH = MH_path + f
        os.chmod(f_MH, S_IWUSR | S_IREAD)  # make destination read/write so we can overwrite
        shutil.copyfile(f_compiled, f_MH)
        os.chmod(f_MH, S_IREAD | S_IRGRP | S_IROTH)


    


