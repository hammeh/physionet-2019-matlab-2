function [score, label] = get_sepsis_score(data, model)
    % Fill the data values forwards in time.
    data = fillmissing(data, 'previous');

    % Populate extra blood pressure column if only one is missing
    data = fillBloodPressure(data);

    % The data we want to classify is the current hour only (so the last row)
    XTest = data(end, :);

    % For each column, cluster using the training cluster means
    for jCol = 1:size(XTest, 2)
        % Calculate the distances
        [val, idx] = pdist2(model.C(jCol, :)', XTest(:, jCol), 'euclidean', 'Smallest', 1);

        % Assign indexes (cluster labels)
        XTest(:, jCol) = idx;

        % Check that any values that are NaN have the missing cluster label
        XTest(isnan(val), jCol) = size(C, 2) + 1;
    end

    % Get the prediction from the trained model
    [~, scores] = predict(model.Mdl, XTest);

    % Get the prediction
    label = scores(:, 2) >= 0.6497;

    % RUSBoostedTree scores are not probabilities, so convert to a psuedo probability
    score = scores(2) / sum(scoresStack);
end

function x = fillBloodPressure(x)
for xHour = 1:size(x, 1)
    if sum(isnan(x(xHour, 4:6))) == 1
        switch find(isnan(x(xHour, 4:6)))
            case 1
                x(xHour, 4) = 3 * x(xHour, 5) - 2 * x(xHour, 6);
            case 2
                x(xHour, 5) = (x(xHour, 4) + 2 * x(xHour, 6)) / 3;
            case 3
                x(xHour, 6) = (3 * x(xHour, 5) - x(xHour, 4)) / 2;
        end
    end
end
end