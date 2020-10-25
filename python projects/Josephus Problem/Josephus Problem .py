def who_will_survive(number_of_people):
    peoples = [1] * number_of_people

    will_be_dead =   1

    for x in range(number_of_people):
        peoples[x] = x + 1

    while len(peoples) > 1:
        if will_be_dead > len(peoples):
            will_be_dead = 1
        elif will_be_dead == len(peoples):
            will_be_dead = 0
        peoples.pop(will_be_dead)
        will_be_dead += 1
    print(str(number_of_people) + " people, only number " + str(peoples[0]) + " survive")


for number_of_people1 in range(2,101):
    who_will_survive(number_of_people1)