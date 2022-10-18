# Filename:demo3_readCSV_IO.py
# Date: 07/20/2022
# Qiang Liu
# NCSU-GTI Summer 2022 Data Science
#------------------import library---------------------
import sys
import math
import os,io,csv
#------------------global variables-------------------
dash = "-" * 80
print(dash)

def WritePersons():
    with open('persons.csv','w',newline='') as csvfile:
        filewriter = csv.writer(csvfile,
                                delimiter=',',
                                quotechar='|',
                                quoting=csv.QUOTE_MINIMAL)

        filewriter.writerow(['Name','Title'])
        filewriter.writerow(['Majed', 'Professor'])
        filewriter.writerow(['Hanxiao Ma', 'Great Student'])
        filewriter.writerow(['Jiazhen Pan', 'Great Student'])
        filewriter.writerow(['Fangpei Yang', 'Great Student'])
    csvfile.close()
    #let us to read same file
    with open('persons.csv', 'r', newline='') as f:
        reader = csv.reader(f)
        for row in reader:
            print(row)
    f.close()


#Activity:
# 1. Pls. read and list all States from the State.txt file
# 2. List top 13 States
def ReadStates():
    with open('States.txt','r') as state:
        print('All States including:')
        for st in state:
            print(st,end='')
        print(dash)
        print('Top 13 States are following:')
        Lnum = 0
        for line in state:
            if Lnum < 13:
                print(line.strip())
                Lnum += 1
            else:
                break
    state.close()
    print(dash)

    with open('States.txt','r') as statefile:
        reader = csv.reader(statefile)
        print(type(reader))
        listStates = []
        for row in reader:
            print(row)
            listStates.append([row])
        print("2- List top 13 States")
        print(listStates[:13])
    statefile.close()
    print(dash)
    #another solution
    infile = open('States.txt','r')
    listState2 = [line.rstrip() for line in infile] #comprehension list
    print(listState2)
    print(listState2[:13])


def main():
    print("Start Program.....")
    WritePersons()
    ReadStates()



#starting point... launch
# __name__ is predefined class attribute
if __name__ == '__main__':
    main()
