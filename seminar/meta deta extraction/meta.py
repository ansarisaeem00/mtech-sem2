from PIL import Image, ExifTags
img = Image.open("../Images/1.jpg")
exif = { ExifTags.TAGS[k]: v for k, v in img._getexif().items() if k in ExifTags.TAGS }
print(exif)
