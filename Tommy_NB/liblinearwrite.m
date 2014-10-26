% Converts a data file from CS229 format to LIBLINEAR format.
% example usage: libsvmwrite('MATRIX.TRAIN', 'MATRIX.TRAIN.LIBLINEAR')
spmatrix = train_x;
[n,m] = size(spmatrix);
category = train_t;
testMatrix = full(spmatrix);
numTestDocs = size(testMatrix, 1);
outputfile = 'data.output';
fid = fopen(outputfile, 'w');
for i=1:numTestDocs,
  label = category(i);
  if (label == 1) fprintf(fid, '1'); end;
  if (label == 2) fprintf(fid, '2'); end;
  if (label == 3) fprintf(fid, '3'); end;
  if (label == 4) fprintf(fid, '4'); end;
  if (label == 5) fprintf(fid, '5'); end;
  if (label == 6) fprintf(fid, '6'); end;
  [I,J,V] = find(spmatrix(i,:)); 
  numNonZero = size(J, 2);
  for j=1:numNonZero,
    fprintf(fid, ' %d:%d', J(j), full(spmatrix(i, J(j))));
  end
  fprintf(fid, '\n');
end%}
