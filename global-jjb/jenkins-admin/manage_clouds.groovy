/*
 * SPDX-License-Identifier: EPL-1.0
 * Copyright (c) 2018 The Linux Foundation and others.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

 /**
  * Manage Jenkins OpenStack cloud configuration
  *
  * This file is used for auto-generation so is quite minimal. The generator
  * code is produced by shell/jenkins-configure-clouds.sh.
  */

import jenkins.plugins.openstack.compute.JCloudsCloud
import jenkins.plugins.openstack.compute.JCloudsSlaveTemplate
import jenkins.plugins.openstack.compute.SlaveOptions
import jenkins.plugins.openstack.compute.slaveopts.BootSource
import jenkins.plugins.openstack.compute.slaveopts.LauncherFactory

def clouds = Jenkins.instance.clouds
clouds.removeAll { it instanceof JCloudsCloud }

// Code below is auto-generated by jenkins-configure-clouds.sh
