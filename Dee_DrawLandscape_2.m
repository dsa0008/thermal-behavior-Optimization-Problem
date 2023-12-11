
fobj = @Dee_Opt_ExpectationMeasure1;

lengthData = 0:0.001:0.015;
diameterData = 0:0.0001:0.001;
 
for i = 1 : size(x_new , 1)
    for j = 1 : size (x_new , 2)
      currentX = [ x_new(i,j) , y_new(i,j) ] ;
      o(i,j) = fobj(currentX);  
    end
end
 
surfc(x_new , y_new , o)
shading  interp
 

xlabel('length')
ylabel('diameter')

% Highlight a specific point
x_highlight = optimalLength;  % Specify the x-coordinate of the point to highlight
y_highlight = optimalDiameter;  % Specify the y-coordinate of the point to highlight
o_highlight = -fobj([x_highlight, y_highlight]);

hold on;
scatter3(x_highlight, y_highlight, o_highlight, 'ro', 'LineWidth', 2);
hold off;


% % Highlight the second point
% x2 = 0.018;  % Specify the x-coordinate of the second point
% y2 = 0.0012;  % Specify the y-coordinate of the second point
% o2 = -fobj([x2, y2]);
% scatter3(x2, y2, o2, 'go', 'LineWidth', 2);
% 
% hold off;


