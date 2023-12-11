function fitness = Dee_Opt_ExpectationMeasure1(x)
 
            perturbed_x = x(1);
            perturbed_y = x (2);

           % Calculate the fitness using the linear model

            fitness = (776.8 + (1.344e+05)*perturbed_x + (-6.339e+06)*perturbed_y + (-2.174e+06)*perturbed_x^2 + (-5.617e+08)*perturbed_x*perturbed_y...
                + (2.017e+10)*perturbed_y^2 + (7.4e+09)*perturbed_x^2*perturbed_y + (7.477e+11)*perturbed_x*perturbed_y^2 ...
            + (-2.52e+13)*perturbed_y^3 + (-5.63e+12)*perturbed_x^2*perturbed_y^2 + (-3.169e+14)*perturbed_x*perturbed_y^3 ...
            + (1.08e+16)*perturbed_y^4);



%           
        end





