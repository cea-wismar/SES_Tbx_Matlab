function TF = isMatlabDevs()
 Condistion1 = ismember(exist('devs','file'),[2,6]);
 Condistion2 = ismember(exist('atomic','file'),[2,6]);
 Condistion3 = ismember(exist('coupled','file'),[2,6]);
 TF = Condistion1 && Condistion2 && Condistion3;
end