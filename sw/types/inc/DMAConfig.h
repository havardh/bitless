#ifndef _DMACONFIG_H_
#define _DMACONFIG_H_

typedef struct {
	void (*dmaInCallback)(unsigned int channel, bool primary, void *user);
	void (*dmaOutCallback)(unsigned int channel, bool primary, void *user);
} DMAConfig;

#endif /* _DMACONFIG_H_ */
