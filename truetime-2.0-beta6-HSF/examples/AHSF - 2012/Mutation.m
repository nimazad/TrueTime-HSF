%--------------------------------------
%Mutation doesn't work when the value
%is zero!!!
%To solve:(V2)
%if input == 0
%    input = MutationScale;
%end
%Small inputs still have problems
%To solve (V3): input + MutationScale;
%Not converging (V4) --> 0.01 * MutationScale
%slow converging (V5) --> 0.1 * MutationScale
%slow converging (V6) --> 0.2 * MutationScale
%--------------------------------------
function Value = Mutation(gene, input)
Value = 0;
while Value<=0 || Value>1
    MutationScale = 0.1 * rand * ((-1)^randint(1,1,[1,2]));
    Value = input + MutationScale;
end
end