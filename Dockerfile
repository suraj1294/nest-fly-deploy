###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM node:18-alpine As development

# Create app directory
WORKDIR /usr/src/app

#RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm
#RUN curl -fsSL https://get.pnpm.io/install.sh | sh -


# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
#COPY --chown=node:node package*.json ./
#COPY --chown=node:node pnpm-lock.yaml ./
COPY --chown=node:node package.json ./

RUN npm i -g npm@latest; \
 # Install pnpm
 npm install -g pnpm; \
 pnpm --version; \
 pnpm setup; \
 mkdir -p /usr/local/share/pnpm &&\
 export PNPM_HOME="/usr/local/share/pnpm" &&\
 export PATH="$PNPM_HOME:$PATH"; \
 pnpm bin -g

# Install app dependencies using the `npm ci` command instead of `npm install`
#RUN npm ci
#RUN exec sh && pnpm fetch --prod

# Bundle app source
COPY --chown=node:node . .

RUN pnpm install --no-frozen-lockfile

# Use the node user from the image (instead of the root user)
USER node

###################
# BUILD FOR PRODUCTION
###################

FROM node:18-alpine As build
#RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm
#RUN curl -fsSL https://get.pnpm.io/install.sh | sh -


WORKDIR /usr/src/app

#COPY --chown=node:node pnpm-lock.yaml ./
#COPY --chown=node:node package*.json ./
COPY --chown=node:node package.json ./

# In order to run `npm run build` we need access to the Nest CLI which is a dev dependency. In the previous development stage we ran `npm ci` which installed all dependencies, so we can copy over the node_modules directory from the development image
COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=node:node . .

RUN npm i -g npm@latest; \
 # Install pnpm
 npm install -g pnpm; \
 pnpm --version; \
 pnpm setup; \
 mkdir -p /usr/local/share/pnpm &&\
 export PNPM_HOME="/usr/local/share/pnpm" &&\
 export PATH="$PNPM_HOME:$PATH"; \
 pnpm bin -g

# Run the build command which creates the production bundle
RUN pnpm run build

# Set NODE_ENV environment variable
ENV NODE_ENV production

# Running `npm ci` removes the existing node_modules directory and passing in --only=production ensures that only the production dependencies are installed. This ensures that the node_modules directory is as optimized as possible
#RUN npm ci --omit=dev && npm cache clean --force
RUN pnpm install --no-frozen-lockfile --prod

USER node

###################
# PRODUCTION
###################

FROM node:18-alpine As production

# Copy the bundled code from the build stage to the production image
COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist


# Start the server using the production build
CMD [ "node", "dist/main.js" ]
