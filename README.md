# Генератор изображений — Tuman

Этот скрипт создаёт 16 процедурных изображений в папку `img/`.

Файлы, добавленные в ветку feature/add-image-generator:
- scripts/generate_16_images.py — основной генератор
- requirements.txt — зависимости (Pillow)
- .gitignore — исключения

Запуск:

```bash
python -m venv .venv
source .venv/bin/activate  # or .\.venv\Scripts\activate on Windows
pip install -r requirements.txt
python scripts/generate_16_images.py
```

Результат: 16 JPG-файлов в папке `img/`.
