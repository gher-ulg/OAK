% class representing a ROMS-HF model
%
% template
% workdir
%
% param should contain:
% NtileI
% NtileJ
% nhis
% navg

%% not any more
%% Varname (string)
%% grdname (string)
%% frcname (cell array)

function retval = ModelROMSHF(dt,script,template,param,scheduler)

self.dt = dt;
self.template = template;
self.p = param;
self.scheduler = scheduler;
self.script = script;

retval = class(self,'ModelROMSHF',Model(dt));