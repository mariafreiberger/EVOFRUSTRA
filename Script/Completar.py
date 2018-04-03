# Get the sequence of the code PDB file, and write to an alignment file
import sys
from modeller import *
from modeller.automodel import *
#import os

code = sys.argv[1]
chain = sys.argv[2]
# Obtengo la secuencia
e = environ()
m = model(e, file=code)
aln = alignment(e)
aln.append_model(m, align_codes=code)
aln.write(file=code+'.ali')

#Alineo la secuencia contra la estructura
env = environ()
aln = alignment(env)
mdl = model(env, file=code, model_segment=('FIRST:'+chain,'LAST:'+chain))
aln.append_model(mdl, align_codes=code+chain, atom_files=code + '.pdb')
aln.append(file=code+'.ali', align_codes=code)
aln.align2d()
aln.write(file=code+'model.ali', alignment_format='PIR')

#Genero el modelo
env = environ()
a = automodel(env, alnfile=code + 'model.ali',
              knowns= code + chain, sequence= code,
              assess_methods=(assess.DOPE, assess.GA341))

a.starting_model = 1
a.ending_model = 1
a.make()

#Borro archivos temporales
os.system('rm *.log')
os.system('rm *.ini')
os.system('rm *.rsr')
os.system('rm *.sch')
os.system('rm *.D*')
os.system('rm *.V*')
os.system('rm *.ali')

