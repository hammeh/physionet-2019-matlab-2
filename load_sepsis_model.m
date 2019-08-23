function model = load_sepsis_model()
    % Load the cluster means
    load('kmeans-cluster-centers-2.mat', 'C');
    model.C = C;

    % Load the compact ensemble
    mdl = loadCompactModel('sepsisRUSBoostTreeEnsemble.mat');
    model.Mdl = mdl;
end
