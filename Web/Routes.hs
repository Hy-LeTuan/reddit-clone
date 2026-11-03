module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

-- The welcome page at '/' is served by the static controller below.
-- Additional [routes|...|] blocks get appended by `new-controller`.
[routes|StaticController
GET /    WelcomeAction
|]

instance AutoRoute SessionsController

[routes|PostsController
GET /Posts PostsAction
GET /NewPost NewPostAction
POST /CreatePost CreatePostAction
GET /ShowPost?postId ShowPostAction
GET /EditPost?postId EditPostAction
POST /UpdatePost?postId UpdatePostAction
POST /UpdateReactionForPostAction?postId&positive UpdateReactionForPostAction
DELETE /DeletePost?postId DeletePostAction
|]


[routes|SubredditsController
GET /Subreddits SubredditsAction
GET /NewSubreddit NewSubredditAction
POST /CreateSubreddit CreateSubredditAction
GET /ShowSubreddit?subredditId ShowSubredditAction
GET /EditSubreddit?subredditId EditSubredditAction
POST /UpdateSubreddit?subredditId UpdateSubredditAction
DELETE /DeleteSubreddit?subredditId DeleteSubredditAction
|]


[routes|UsersController
GET /Users UsersAction
GET /NewUser NewUserAction
POST /CreateUser CreateUserAction
GET /ShowUser?userId ShowUserAction
GET /EditUser?userId EditUserAction
POST /UpdateUser?userId UpdateUserAction
DELETE /DeleteUser?userId DeleteUserAction
|]


[routes|CommentsController
GET /Comments CommentsAction
GET /NewComment?userId&postId NewCommentAction
POST /CreateComment CreateCommentAction
GET /ShowComment?commentId ShowCommentAction
GET /EditComment?commentId EditCommentAction
POST /UpdateComment?commentId UpdateCommentAction
DELETE /DeleteComment?commentId DeleteCommentAction
|]


[routes|UserReactionsController
GET /UserReactions UserReactionsAction
GET /NewUserReaction NewUserReactionAction
POST /CreateUserReaction CreateUserReactionAction
GET /ShowUserReaction?userReactionId ShowUserReactionAction
GET /EditUserReaction?userReactionId EditUserReactionAction
POST /UpdateUserReaction?userReactionId UpdateUserReactionAction
DELETE /DeleteUserReaction?userReactionId DeleteUserReactionAction
|]
