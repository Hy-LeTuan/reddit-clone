CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    upvotes INT DEFAULT 0 NOT NULL,
    downvotes INT DEFAULT 0 NOT NULL,
    subreddit_id UUID NOT NULL
);
CREATE INDEX posts_created_at_index ON posts (created_at);
CREATE INDEX posts_user_id_index ON posts (user_id);
CREATE TABLE subreddits (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL
);
CREATE INDEX subreddits_created_at_index ON subreddits (created_at);
CREATE INDEX posts_subreddit_id_index ON posts (subreddit_id);
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    handle TEXT NOT NULL,
    display TEXT NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT null,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
ALTER TABLE users ADD CONSTRAINT users_handle_key UNIQUE(handle);
CREATE TABLE comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    user_id UUID NOT NULL,
    post_id UUID NOT NULL,
    upvotes INT DEFAULT 0 NOT NULL,
    downvotes INT DEFAULT 0 NOT NULL,
    parent_id UUID DEFAULT null
);
CREATE INDEX comments_created_at_index ON comments (created_at);
CREATE INDEX comments_user_id_index ON comments (user_id);
CREATE INDEX comments_post_id_index ON comments (post_id);
ALTER TABLE comments ADD CONSTRAINT comments_ref_parent_id FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE NO ACTION;
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE comments ADD CONSTRAINT comments_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE posts ADD CONSTRAINT posts_ref_subreddit_id FOREIGN KEY (subreddit_id) REFERENCES subreddits (id) ON DELETE NO ACTION;
ALTER TABLE posts ADD CONSTRAINT posts_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
