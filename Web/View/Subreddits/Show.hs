module Web.View.Subreddits.Show where
import Web.View.Prelude

data ShowView = ShowView { subreddit :: Subreddit }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Subreddit</h1>
        <dl>
            <dt>Name</dt><dd>{subreddit.name}</dd>
            <dt>Description</dt><dd>{subreddit.description}</dd>
        </dl>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Subreddits" SubredditsAction
                            , breadcrumbText "Show Subreddit"
                            ]