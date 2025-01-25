import express from 'express';
import * as ArticleRepository from '../repository/ArticleRepository.js';
import * as Db from '../service/Database.js'; // Pridáme tento import
const router = express.Router();

/**
 * Uvodna stranka
 */
router.get("/", async (req, res) => {
    const sortBy = req.query.sortBy || 'event_date';
    let articles = await ArticleRepository.findAll(null, sortBy); // Pass null to filter only public articles

    res.render('index/index.html.njk', {
        articles: articles,
        sortBy: sortBy
    });
});

/**
 * Detail podujatia
 */
router.get("/article/:articleId", async (req, res) => {
    let articleId = req.params.articleId;
    let article = await ArticleRepository.find(articleId);
    let comments = await ArticleRepository.findComments(articleId);

    res.render('index/article_detail.html.njk', {
        article: article,
        comments: comments,
        user: req.session.user,
        getFlashMessages: req.flash.bind(req)
    });
});

/**
 * Pridanie komentara
 */
router.post("/article/:articleId/comment", async (req, res) => {
    let articleId = req.params.articleId;
    let username = req.body.username || (req.session.user && req.session.user.username);
    let comment = req.body.comment;

    // Overenie, či meno už nie je použité
    let existingUser = await Db.query(
        'SELECT * FROM users WHERE username = :username',
        { username: username }
    );

    if (existingUser.length > 0 && (!req.session.user || req.session.user.username !== username)) {
        req.flash('error', 'Username already taken');
        return res.redirect(`/article/${articleId}`);
    }

    await Db.query(
        'INSERT INTO comments (article_id, username, comment) VALUES (:articleId, :username, :comment)',
        { articleId: articleId, username: username, comment: comment }
    );

    res.redirect(`/article/${articleId}`);
});

/**
 * Zmazanie komentara
 */
router.post("/article/:articleId/comment/:commentId/delete", async (req, res) => {
    let commentId = req.params.commentId;

    await ArticleRepository.deleteComment(commentId);

    res.redirect(`/article/${req.params.articleId}`);
});

export {router as IndexController}
