import csv

f = open("temp_sintomas.csv", "r+")
f2 = open("temp_sintomas_NEW.csv", "w+")

#Insere o VAERS_ID;SYMPTOM1;SYMPTOM2;SYMPTOM3;SYMPTOM4;SYMPTOM5
line1 = list(csv.reader(f, delimiter=';'))[0]
newLine1 = ';'.join(line1)
f2.writelines(newLine1)
f2.write('\n')
f.close()     

lista = []

#Insere o resto
with open("temp_sintomas.csv",newline='') as csvfile:
    data = list(csv.reader(csvfile, delimiter=';'))[1:]
    
for line in data:     
    if(line[1] and (line[0], line[1]) not in lista):
        lista.append((line[0], line[1]))
    else:
        line[1] = ''

    if(line[2] and (line[0], line[2]) not in lista):
        lista.append((line[0], line[2]))
    else:
        line[2] = ''    
    
    if(line[3] and (line[0], line[3]) not in lista):
        lista.append((line[0], line[3]))
    else:
        line[3] = ''       

    if(line[4] and (line[0], line[4]) not in lista):
        lista.append((line[0], line[4]))
    else:
        line[4] = ''           

    if(line[5] and (line[0], line[5]) not in lista):
        lista.append((line[0], line[5]))
    else:
        line[5] = ''           

    newLine = ';'.join(line)
    f2.writelines(newLine)
    f2.writelines('\n')     







 
 

    

