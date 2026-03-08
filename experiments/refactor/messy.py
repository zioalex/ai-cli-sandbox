# NOTE: This code is intentionally written with poor style for the refactoring exercise.
def calc(a,b,op):
    if op=='add':
        r=a+b
    elif op=='sub':
        r=a-b
    elif op=='mul':
        r=a*b
    elif op=='div':
        if b==0:
            print("error: divide by zero")
            return None
        r=a/b
    else:
        print("error: unknown op")
        return None
    return r

x=10
y=3
print(calc(x,y,'add'))
print(calc(x,y,'sub'))
print(calc(x,y,'mul'))
print(calc(x,y,'div'))
print(calc(x,0,'div'))
