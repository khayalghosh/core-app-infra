import React from "react";

export default function Posts() {
    return (
        <section className="posts">
            <div className="container">
                <h2>Latest News Articles</h2>
                <div className="post-list">
                    <article className="post">
                        <h3>Article Title 1</h3>
                        <p>This is a summary of the first news article.</p>
                    </article>
                    <article className="post">
                        <h3>Article Title 2</h3>
                        <p>This is a summary of the second news article.</p>
                    </article>
                    <article className="post">
                        <h3>Article Title 3</h3>
                        <p>This is a summary of the third news article.</p>
                    </article>
                </div>
            </div>
        </section>
    );
}