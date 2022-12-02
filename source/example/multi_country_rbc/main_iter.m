gdsge_codegen('rbc');

tt = tic;
options = struct;
iterRslt = iter_rbc(options);
toc(tt);

save('IterRslt','iterRslt');

