function y=quantize(input,q,FIELDNOTSET)
if input==FIELDNOTSET;
    y=FIELDNOTSET;
else
    y=q*round(input/q);
end