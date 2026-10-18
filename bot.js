const TelegramBot = require('node-telegram-bot-api');
const token = process.env.BOT_TOKEN;
const bot = new TelegramBot(token, { polling: true });

const PRIVATE_CHANNEL = '-100XXXXX';
const PUBLIC_CHANNEL = '-100XXXXX';

const SITUATIONS = [
    'Туман сдвинулся.',
    'Кто-то сделал шаг.',
    'Костёр тлеет.',
    'Прилив отступил.',
    'Тишина. Не пустота. Пауза.',
    'След обрывается. Но туман сдвинулся.',
    'Кто-то молчит. Туман не осуждает.',
    'Берег ждёт.'
];

function randomSituation() {
    return SITUATIONS[Math.floor(Math.random() * SITUATIONS.length)];
}

function pushPrivate(text) {
    bot.sendMessage(PRIVATE_CHANNEL, text).catch(() => {});
}

function pushPublic(text) {
    bot.sendMessage(PUBLIC_CHANNEL, text).catch(() => {});
}

setInterval(() => {
    pushPrivate('🌫️ ' + randomSituation());
}, 3600000);

setInterval(() => {
    pushPublic('🌫️ ' + randomSituation());
}, 7200000);

bot.onText(/\/start/, (msg) => {
    bot.sendMessage(msg.chat.id, 'Туман. Ты здесь. Сделай шаг.');
});

bot.onText(/\/roll/, (msg) => {
    pushPrivate('🌫️ Ролл. Туман отступил.');
});

bot.onText(/\/status/, (msg) => {
    pushPrivate('🌫️ Берег ждёт. 4 шага в сутки. Сброс 00:00 UTC.');
});
