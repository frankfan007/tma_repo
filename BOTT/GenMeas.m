%%  Hasan Hüseyin Sönmez - 29.09.2018
%   Generate measurement data

%%  Inputs:
%               gt      : ground truth data (targets, ownship, birth and
%                           death, etc)
%               model   : model parameters

function Measures = GenMeas(gt, model, Measures)

Measures.Z      = cell(model.K,1);       % initialize measurement structure
Measures.Theta  = cell(model.K,1);       % initialize true bearing structure
%% for batch data generation
for k = 1:model.K
    % if any target is present
    Pd = model.pD;
    idx = find(rand <= Pd );                    % if a target is detected
    tt = gt.X{k}(:,idx);                        % state of the targets
    own = gt.Ownship(:,k);
    [Measures.Z{k}, Measures.Theta{k}] = MeasFcn(tt, own, model, true);   % generate measurement using appropriate model
    Nc = poissrnd(model.Lambda);                % number of clutter points
    C = repmat(model.range_cz(:,1), [1 Nc]) + diag(model.range_cz*[-1;1])*rand(model.zDim, Nc);  % generate clutter points
    Measures.Z{k} = [Measures.Z{k}, C];         % measurement set at time k
end


end