import express from 'express';
import * as Db from '../service/Database.js';
import * as ArticleRepository from '../repository/ArticleRepository.js';
import * as ArticleService from '../service/ArticleService.js';
import {authorize} from '../service/Security.js';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import { rename } from 'fs/promises';

// Pomocné funkcie
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Adresár kam sa budú ukladať súbory
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, '../public/uploads/'));
    },
    filename: (req, file, cb) => {
        const articleId = req.body.id || 0;
        cb(null, `${articleId}.jpg`);
    }
});

const upload = multer({ storage: storage });

const router = express.Router();

router.use(express.urlencoded({ extended: true }));

// Pridáme middleware na overenie prístupu pre celú sekciu článkov
router.use(authorize('admin'));

/**
 * Zoznam článkov
 */
router.get("/", async (req, res) => {
    const sortBy = req.query.sortBy || 'event_date';
    let articles = await ArticleRepository.findAll(req.session.user, sortBy);

    res.render('article/index.html.njk', {
        articles: articles,
        sortBy: sortBy
    });
});

/**
 * Uložiť nový alebo upravený článok
 */
router.post("/edit/:articleId", upload.single('image'), async (req, res) => {
    let location_id = req.body.location_id ? parseInt(req.body.location_id, 10) : null;

    let article = {
        id: parseInt(req.params.articleId, 10),
        title: req.body.title,
        content: req.body.content,
        eventType: req.body.eventType,
        eventDate: req.body.eventDate,
        region: req.body.region,
        district: req.body.district,
        city: req.body.city,
        address: req.body.address,
        location_id: isNaN(location_id) ? null : location_id,
        isPrivate: req.body.isPrivate ? 1 : 0
    };

    // Ak je adresa null, pridáme novú lokalitu do tabuľky locations
    if (article.city && article.district && article.region) {
        let existingLocation = await Db.query(
            'SELECT id FROM locations WHERE location = :city AND district = :district AND region = :region AND address IS NULL',
            { city: article.city, district: article.district, region: article.region }
        );

        if (existingLocation.length === 0) {
            let result = await Db.query(
                'INSERT INTO locations (location, district, region, address) VALUES (:city, :district, :region, NULL)',
                { city: article.city, district: article.district, region: article.region }
            );
            article.location_id = result.insertId;
        } else {
            article.location_id = existingLocation[0].id;
        }
    }

    if (article.location_id === null) {
        return res.status(400).send('Location ID cannot be null');
    }

    let articleId = await ArticleService.saveArticle(article);

    // Ak sa jedná o nový článok, premenujem obrázok z 0.jpg na správne ID
    if (article.id === 0) {
        try {
            let oldName = path.join(__dirname, '../public/uploads/') + `0.jpg`;
            let newName = path.join(__dirname, '../public/uploads/') + `${articleId}.jpg`;

            await rename(oldName, newName); // vyvolá výnimku, ak súbor neexistuje.
        } catch {
            // Súbor neexistuje - nebol uploadnutý
        }
    }

    res.redirect('/article');
});

/**
 * Zobraziť formulár na úpravu alebo vytvorenie článku
 */
router.get("/edit/:articleId", async (req, res) => {
    let articleId = parseInt(req.params.articleId, 10);
    let article = await ArticleRepository.find(articleId);

    // Ak sa článok nenašiel, vytvoríme nový
    if (article === null) {
        article = {
            id: 0,
            title: '',
            content: '',
            eventType: '',
            eventDate: '',
            region: '',
            district: '',
            city: '',
            address: '',
            location_id: null,
            isPrivate: 0
        };
    }

    // Získame zoznam všetkých lokalít
    let locations = await Db.query("SELECT * FROM locations ORDER BY region, district, location");

    // Extrahujeme unikátne regióny, okresy a mestá
    let regions = [...new Set(locations.map(l => l.region))];
    let districts = [...new Set(locations.map(l => l.district))];
    let cities = [...new Set(locations.filter(l => l.address === null).map(l => l.location))];

    res.render('article/edit.html.njk', {
        article: article,
        regions: regions,
        districts: districts,
        cities: cities,
        locations: locations
    });
});

export { router as ArticleController }
