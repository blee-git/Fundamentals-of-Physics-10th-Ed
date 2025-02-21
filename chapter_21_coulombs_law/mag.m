function m = mag(v)
% mag(v) computes magnitude of a two dimensional vector
    s = size(v,2);
    if s == 2
        m = sqrt(v(1)^2+v(2)^2);
    elseif s == 3
        m = sqrt(v(1)^2+v(2)^2+v(3)^2);
    else
        disp("size of v must be 2 or 3")
        quit
    end
end