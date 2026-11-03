module Web.View.Subreddits.Index where
import Web.View.Prelude

data IndexView = IndexView { subreddits :: [Subreddit] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewSubredditAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach subreddits renderSubreddit}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Subreddits" SubredditsAction
                ]

renderSubreddit :: Subreddit -> Html
renderSubreddit subreddit = [hsx|
    <tr>
        <td>{subreddit.name}</td>
        <td>{subreddit.description}</td>
        <td><a href={ShowSubredditAction subreddit.id}>Show</a></td>
        <td><a href={EditSubredditAction subreddit.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteSubredditAction subreddit.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]