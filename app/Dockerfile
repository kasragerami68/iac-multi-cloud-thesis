FROM nginx:alpine

# کپی فایل‌های HTML/CSS
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# پورت
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]