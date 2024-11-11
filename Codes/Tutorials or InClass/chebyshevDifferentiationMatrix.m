function [D] = chebyshevDifferentiationMatrix(n, xnodes)
    % Input: n - number of Chebyshev nodes 
    % Output: D - differentiation matrix (size n by n)
    %         x - Chebyshev nodes (size n, column vector)
    
    % Compute Chebyshev nodes
    %x_cheby = sort(cos(pi * (1:2:2*n-1) / (2*n)));  % Chebyshev nodes 

    % Initialize differentiation matrix
    D = zeros(n, n);
    
    for i=1:n
        %x = xnodes(i);
        xnodes(i);
        % Loop through each Lagrange basis polynomial
        for k = 1:n
            xk = xnodes(k); % Current node lagrange basis

            if i==k
                for j = 1:n
                    if j ~= k  % Skip the term where j == k
                        D(i,k) = D(i,k) + 1/(xk - xnodes(j));
                    end
                end            
                
            else        
            
            numerator = 1;  % Initialize numerator to 1
            denominator = 1;  % Initialize denominator to 1
            
            % Numerator loop (for xnodes(i) - [xnodes(1:k-1)
            % xnodes(k+1:end)]) skipping one term for addition
            for j = 1:n
                if j ~= k && j~=i % Skip the term where j == k and j==p
                    numerator = numerator * (xnodes(i) - xnodes(j));
                end
            end
            
            % Denominator loop (for xk - [xnodes(1:k-1) xnodes(k+1:end)])
            for j = 1:n
                if j ~= k  % Skip the term where j == k
                    denominator = denominator * (xk - xnodes(j));
                end
            end
            
            % Now calculate the result
            D(i,k) = (numerator / denominator)  ; 
            end
        end
    end

end

% function [D, xnodes] = chebyshevDifferentiationMatrix(n)
%     % Input: n - number of Chebyshev nodes 
%     % Output: D - differentiation matrix (size n+1 by n+1)
%     %         xnodes - Chebyshev nodes (size n+1, column vector)
% 
%     % Compute Chebyshev nodes
%     xnodes = cos(pi * (0:n-1) / n-1)';  % Chebyshev nodes (column vector)
% 
%     % Initialize differentiation matrix
%     D = zeros(n, n);
%     
%     % Vector of coefficients for the differentiation matrix
%     c = [2; ones(n-1, 1); 2] .* (-1).^(0:n)';  % c_j coefficients
% 
%     % Fill differentiation matrix D
%     for i = 1:n
%         for j = 1:n
%             if i ~= j
%                 % Off-diagonal entries
%                 D(i,j) = c(i) / c(j) * (-1)^(i+j) / (xnodes(i) - xnodes(j));
%             end
%         end
%     end
% 
%     % Diagonal entries
%     for i = 2:n  % For 1 < i < n
%         D(i,i) = -xnodes(i) / (2 * (1 - xnodes(i)^2));
%     end
% 
%     % Special cases for the endpoints (i = 1, i = n+1)
%     D(1,1) = (2*n^2 + 1) / 6;
%     D(n,n) = -(2*n^2 + 1) / 6;
% end
