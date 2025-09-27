function y = lagrange(x,Xn,i)
N = length(Xn);
without_i = [Xn(1,1:i-1), Xn(1,i+1:end)]';
num = prod(x*ones(N-1,1) - without_i);
den = prod(Xn(i)*ones(N-1,1) - without_i);
y = num/den;
end