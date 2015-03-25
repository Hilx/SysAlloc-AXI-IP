t = 1:1:50;

a = 0.225;
y0 = exp(a*t);
size = 100* ceil(y0(1)*y0)
delay = ceil(size/4);
plot(t,size)
plot(t,delay)

