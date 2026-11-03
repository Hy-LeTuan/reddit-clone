module Web.View.Subreddits.New where
import Web.View.Prelude

data NewView = NewView { subreddit :: Subreddit }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Subreddit</h1>
        {renderForm subreddit}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Subreddits" SubredditsAction
                , breadcrumbText "New Subreddit"
                ]

renderForm :: Subreddit -> Html
renderForm subreddit = formFor subreddit [hsx|
    {(textField #name)}
    {(textField #description)}
    {submitButton}

|]