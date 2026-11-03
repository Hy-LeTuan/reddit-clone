module Web.View.Posts.New where
import Web.View.Prelude

data NewView = NewView { post :: Post, user :: User, subreddits :: [Subreddit] }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Post by '{user.handle}'</h1>
        {renderForm subreddits post}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                , breadcrumbText "New Post"
                ]

renderSubreddit :: (Int, Subreddit) -> Html
renderSubreddit (i, subreddit) = [hsx|
    <option value={subreddit.name}>{i + 1}. r/{subreddit.name}</option>
|]

renderForm :: [Subreddit] -> Post -> Html
renderForm subreddits post = formFor post [hsx|
    {(selectField #subredditId subreddits)}
    {(hiddenField #userId)}
    {(textField #title)}
    {(textField #body)}
    {(hiddenField #upvotes)}
    {(hiddenField #downvotes)}
    {submitButton}
|]
