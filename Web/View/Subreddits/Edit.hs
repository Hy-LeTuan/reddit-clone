module Web.View.Subreddits.Edit where
import Web.View.Prelude

data EditView = EditView { subreddit :: Subreddit }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Subreddit</h1>
        {renderForm subreddit}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Subreddits" SubredditsAction
                , breadcrumbText "Edit Subreddit"
                ]

renderForm :: Subreddit -> Html
renderForm subreddit = formFor subreddit [hsx|
    {(textField #name)}
    {(textField #description)}
    {submitButton}

|]