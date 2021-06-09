f = open("2021VAERSDATA_Formatado-Cópia.csv", "r+")
f2 = open("2021VAERSDATA_Formatado-Cópia2.csv", "w+")

split = []
newLine = ""

f.readline()
for line in f.readlines() :
    split = line.split(";")

    if(split[1]):
        data = split[1]
        nd = data.split("/")
        newDate = nd[2] + "-" + nd[0] + "-" + nd[1]
        split[1] = newDate
        
    if(split[8]):
        data = split[8]
        nd = data.split("/")
        newDate = nd[2] + "-" + nd[0] + "-" + nd[1]
        split[8] = newDate
 
    if(split[5]):
        data = split[5]
        nd = data.split("/")
        newDate = nd[2] + "-" + nd[0] + "-" + nd[1]
        split[5] = newDate
  
    if(split[9]):
        data = split[9]
        nd = data.split("/")
        newDate = nd[2] + "-" + nd[0] + "-" + nd[1]
        split[9] = newDate
 
    newLine = ';'.join(split)
    f2.writelines(newLine)

