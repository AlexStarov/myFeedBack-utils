FROM nginx:alpine

# Remove default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY api.feedback-app.pp.ua.conf /etc/nginx/conf.d/
COPY app.feedback-app.pp.ua.conf /etc/nginx/conf.d/
COPY site.feedback-app.pp.ua.conf /etc/nginx/conf.d/
COPY frontend.feedback-app.pp.ua.conf /etc/nginx/conf.d/

# Create directory for static files (QR codes)
RUN mkdir -p /var/www/feedback-app/static/qr

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]