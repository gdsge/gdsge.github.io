function shock = gen_discrete_markov_rn_with_agg(trans,numPaths,lenPath,initShock,aggIdx)
% Generate random numbers with aggregate index, respeting law of large
% numbers
numStates = size(trans,1);

shock = zeros(numPaths,lenPath);
shock(:,1) = initShock;

cumTrans = cumsum(trans, 2);

for t=1:lenPath-1
    for j=1:numStates
        % Find samples that has shock j
        idxOfShockJ = find(shock(:,t)==j);
        % Fill in numbers based on distribution weights
        % un = linspace(1e-10,1-1e-10,length(idxOfShockJ));
        un = rand(length(idxOfShockJ),1);
        % Look up trans_j
        [~,shock(idxOfShockJ,t+1)] = histc(un, [0 cumTrans(j,:,aggIdx(t),aggIdx(t+1))]);
        % Shuffle random numbers
        % shock(idxOfShockJ,t+1) = Shuffle(shock(idxOfShockJ,t+1));
    end
end
end