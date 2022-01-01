PATH=$PATH:/opt/homebrew/bin
echo Starting lernOS Guide Generation ...

# Variables
filename="lernOS-ePortfolio-Guide-en"
chapters="./src/index.md ./src/1-0-Basics.md ./src/2-0-Learning-Pathway.md ./src/2-1-Learning-area-1.md ./src/2-1-Learning-area-2.md ./src/2-1-Learning-area-3.md ./src/2-1-Learning-area-4.md ./src/2-1-Learning-area-5.md ./src/2-1-Learning-area-6.md ./src/2-1-Learning-area-7.md ./src/3-0-Lessons-Learned.md ./src/4-0-Appendix.md"

# Delete Old Versions
echo Deleting old versions ...
rm -rf $filename.*
rm -rf ../docs/de/*
#rm -ff ../docs/de-slides/index.html

# Create Web Version (mkdocs)
echo Creating Web Version ...
mkdocs build

# Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" -F mermaid-filter --number-sections -V lang=de-de -o $filename.docx $chapters

# Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" -F mermaid-filter --number-sections -V lang=de-de -o $filename.html $chapters

# Create PDF Version (pdf)
echo Creating PDF version ...
pandoc metadata.yaml --from markdown -s --resource-path="./src" -F mermaid-filter --template lernos --number-sections --toc -V lang=de-de -o $filename.pdf $chapters

# Create eBook Versions (epub, mobi)
echo Creating eBook versions ...
magick -density 300 $filename.pdf[0] src/images/ebook-cover.jpg
mogrify -size 2500x2500 -resize 2500x2500 src/images/ebook-cover.jpg
mogrify -crop 1563x2500+102+0 src/images/ebook-cover.jpg
pandoc metadata.yaml --from markdown -s --resource-path="./src" -F mermaid-filter --epub-cover-image=src/images/ebook-cover.jpg --number-sections --toc -V lang=de-de -o $filename.epub $chapters
ebook-convert $filename.epub $filename.mobi

# Create Slides (revealjs)
# echo Creating Presentation ...
# pandoc metadata.yaml --from markdown -s --resource-path="./src" -t revealjs -V theme=night -s ./slides/index.md -o ../docs/de-slides/index.html